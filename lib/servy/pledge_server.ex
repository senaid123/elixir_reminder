defmodule Servy.PledgeServer do

  @name :pledge_server

  def start do
    IO.puts "Starting pledge server"
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end



  def create_pledge(name, amount) do
    send @name, {self(), :create_pledgde, name, amount}
    receive do {:response, status} ->  status end
  end

  def recent_pledges do
    send @name, {self(), :recent_pledges}

    receive do {:response, pledges} ->  pledges end
  end

  def total_pledged do
    send @name, {self(), :total_pledged}

    receive do {:response, total} ->  total end
  end

  def listen_loop(state) do
    IO.puts "\nWaiting for a message..."

    receive do
      {sender, :create_pledge, name, amount} ->
         {:ok, id} = send_pledge_to_service(name,amount)
          most_recent_pleges = Enum.take(state, 2)
          new_state = [{name, amount} | most_recent_pleges ]
          listen_loop(new_state)
          send sender, {:response, id}
      {sender, :recent_pledges} ->
          send sender, {:response, state}
          listen_loop(state)
      {sender, :total_pledged} ->
        total= Enum.map(state, &elem(&1, 1)) |> Enum.sum()
        send sender, {:response, total}
        listen_loop(state)
    end

  end

  defp send_pledge_to_service(_name, _amount) do

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end

alias Servy.PledgeServer

pid = PledgeServer.start()

PledgeServer.create_pledge("larry", 10)
PledgeServer.create_pledge("moe", 20)
PledgeServer.create_pledge("curly", 30)
PledgeServer.create_pledge("daisy", 40)
PledgeServer.create_pledge("grace", 50)

IO.inspect PledgeServer.recent_pledges()
IO.inspect PledgeServer.total_pledged()
