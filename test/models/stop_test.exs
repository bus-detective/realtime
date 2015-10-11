defmodule BdRt.StopDirectionTest do

  alias BdRt.Agency
  alias BdRt.Stop

  defmodule Direction do
    use BdRt.ModelCase

    test 'direction inbound is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALi" }
      assert Stop.direction(stop) == "inbound"
    end

    test 'direction outbound is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALo" }
      assert Stop.direction(stop) == "outbound"
    end

    test 'direction northbound is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALn" }
      assert Stop.direction(stop) == "northbound"
    end

    test 'direction southbound is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALs" }
      assert Stop.direction(stop) == "southbound"
    end

    test 'direction eastbound is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALe" }
      assert Stop.direction(stop) == "eastbound"
    end

    test 'direction westbound is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALw" }
      assert Stop.direction(stop) == "westbound"
    end

    test 'direction unknown is determined by the remote id' do
      stop = %Stop{ remote_id: "8THWALR" }
      assert Stop.direction(stop) == nil
    end
  end


  defmodule Search do
    use BdRt.ModelCase
    alias BdRt.TsqueryBuilder

    setup do
      {:ok, agency} = BdRt.Repo.insert(%Agency{})
      {:ok, stop} = BdRt.Repo.insert(%Stop{agency_id: agency.id, name: "Geoff's Stop"})

      {:ok, stop: stop }
    end

    test 'can find stops by name', %{stop: stop} do
      results = Stop.search(TsqueryBuilder.build(stop.name)) |> BdRt.Repo.all
      assert results == [stop]
    end
  end
end

