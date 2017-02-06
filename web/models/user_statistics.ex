defmodule Backlash.UserStatistics do
  use Backlash.Web, :model

  alias Backlash.User
  alias Backlash.Repo

  def total_users do
    q = from q in User, select: count(q.id)
    Repo.one q
  end

  def statistics do
    [
      {"Total users", total_users}
    ]
  end
end
