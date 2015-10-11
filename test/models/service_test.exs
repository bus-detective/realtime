defmodule BdRt.ServiceTest do
  use BdRt.ModelCase

  alias BdRt.Service
  alias BdRt.Agency

  @time {2015, 4, 23}
  setup do
    {:ok, agency} = BdRt.Repo.insert(%Agency {})
    {:ok, applicable_service } = BdRt.Repo.insert(%Service { agency_id: agency.id, thursday: true, start_date: Ecto.Date.from_erl({2015, 1, 1}), end_date: Ecto.Date.from_erl({2015, 12, 31}) })
    {:ok, non_applicable_service } = BdRt.Repo.insert(%Service { agency_id: agency.id, friday: true, start_date: Ecto.Date.from_erl({2015, 1, 1}), end_date: Ecto.Date.from_erl({2015, 12, 31}) })

    {:ok, agency: agency, applicable_service: applicable_service, non_applicable_service: non_applicable_service }
  end

  test 'finds services at a specific time', %{applicable_service: applicable_service} do
    services = Service.for_time(@time) |> BdRt.Repo.all
    assert Enum.count(services) == 1
    assert List.first(services).thursday
  end
end

