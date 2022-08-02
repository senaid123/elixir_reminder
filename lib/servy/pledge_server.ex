defmodule Servy.PledgeServer do

  def listen_loop(state) do
    IO.puts "\nWaiting for a message..."

    receive do
      {:create_pledge, name, amount} ->
         {:ok, id} = send_pledge_to_service(name,amount)

         new_state = [{name, amount} | state ]

        IO.puts "#{name} pledged #{amount}!"
        IO.puts "new state is #{inspest new_state}"
        listen_loop(new_state)
       {sender. :recent_pledges} ->
          send sender, {:response, state}
          IO.puts "Send pledges to #{inspect sender}"
          listen_loop(state)
    end

  end




  def create_pledge(pid, name, amount) do
    send pid, {:create_pledgde, name, amount}
  end

  def recent_pledges do
    send pid, {self(), :recent_pledges}

    receive do {:response, pledges} -> IO.inspect pledges end
   end

  defp send_pledge_to_service(_name, _amount) do

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  alias Servy.PledgeServer

  pid = spawn(PledgeServer, :listen_loop, [[]])

  PledgeServer.create_pledge(pid, "larry", 10)
  PledgeServer.create_pledge(pid, "moe", 20)
  PledgeServer.create_pledge(pid, "curly", 30)
  PledgeServer.create_pledge(pid, "daisy", 40)
  PledgeServer.create_pledge(pid, "grace", 50)

end
