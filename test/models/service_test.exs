defmodule BdRt.ServiceTest do
  use BdRt.ModelCase

  alias BdRt.Service
  alias BdRt.Agency

  @time {2015, 4, 23}
  setup do
    agency = insert(:agency)
    applicable_service = insert(:service, agency: agency, thursday: true, start_date: Timex.Date.from_erl({2015, 1, 1}), end_date: Timex.Date.from_erl({2015, 12, 31}))
    non_applicable_service = insert(:service, agency: agency, friday: true, start_date: Timex.Date.from_erl({2015, 1, 1}), end_date: Timex.Date.from_erl({2015, 12, 31}))

    {:ok, agency: agency, applicable_service: applicable_service, non_applicable_service: non_applicable_service}
  end

  test 'finds services at a specific time' do
    services = Service.for_time(@time) |> BdRt.Repo.all
    assert Enum.count(services) == 1
    assert List.first(services).thursday
  end
end

