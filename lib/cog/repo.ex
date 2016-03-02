defmodule Cog.Repo do
  use Ecto.Repo, otp_app: :cog

  import Cog.Repo.Bundle, only: [bundle_status: 1,
                                 bundle_is_enabled?: 1,
                                 enable_bundle: 1,
                                 disable_bundle: 1],
                          warn: false

end
