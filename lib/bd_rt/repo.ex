defmodule BdRt.Repo do
  use Ecto.Repo, otp_app: :bd_rt

  def execute(sql, params \\ []) do
    Ecto.Adapters.SQL.query!(__MODULE__, sql, params)
  end
end
