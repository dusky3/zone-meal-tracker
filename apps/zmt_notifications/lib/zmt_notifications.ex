defmodule ZMTNotifications do
  @moduledoc """
  Internal API for notifications system
  """

  import __MODULE__.Guards

  alias __MODULE__.Impl

  @behaviour Impl

  @type email :: String.t()
  @type user_id :: String.t()

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.DefaultImpl

  @doc """
  Sets the email address for a given user id.

  This only sets the email address for Notifications,
  not the login email. This reduces coupling between
  notifications and accounts.
  """
  @impl true
  @spec set_user_email(user_id, email) :: :ok | {:error, :invalid_user_id}
  def set_user_email(user_id, email) when is_user_id(user_id) and is_email(email) do
    current_impl().set_user_email(user_id, email)
  end

  @doc """
  Sends a welcome message to the given user
  """
  @impl true
  @spec send_welcome_message(user_id) :: :ok | {:error, :unknown_user_id}
  def send_welcome_message(user_id) when is_user_id(user_id) do
    current_impl().send_welcome_message(user_id)
  end

  @type reset_opt :: {:force, true}

  @doc """
  Deletes all data from the notifications system.

  This is used in integration testing and should rarely
  be called. Since this is such a dangerous function, it
  must be called with `force: true`.
  """
  @impl true
  @spec reset([reset_opt]) :: :ok
  def reset(opts) when is_list(opts) do
    current_impl().reset(opts)
  end

  defp current_impl do
    Application.get_env(:zmt_notifications, :impl, __MODULE__.DefaultImpl)
  end
end
