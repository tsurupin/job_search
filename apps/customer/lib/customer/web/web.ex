defmodule Customer.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Customer.Web, :controller
      use Customer.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Timex.Ecto.Timestamps

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      alias Customer.Repo

      Customer.Web.shared
    end
  end

  def crud do
     quote do
       import Ecto
       import Ecto.Changeset
       import Ecto.Query, only: [from: 1, from: 2, first: 1]
       alias Customer.Repo
       alias Ecto.Multi

       Customer.Web.shared
     end
  end

  def service do
    quote do
      alias Customer.Repo

      Customer.Web.shared
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: Customer.Web
      use Guardian.Phoenix.Controller
      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      alias Customer.Repo
      import Ecto
      import Ecto.Query

      import Customer.Web.Router.Helpers
      import Customer.Web.Gettext

      alias Customer.Es
      alias Customer.Error
      alias Customer.Repo


      Customer.Web.shared
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/customer/web/templates", namespace: Customer.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Customer.Web.Router.Helpers
      import Customer.Web.ErrorHelpers
      import Customer.Web.Gettext

      Customer.Web.shared

    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Customer.Repo
      import Ecto
      import Ecto.Query
      import Customer.Web.Gettext
    end
  end

  defmacro shared do
    quote do
      alias Customer.Web.{
        Area,
        Authorization,
        Company,
        Job,
        Company,
        JobSource,
        JobSourceTechKeyword,
        JobTechKeyword,
        JobApplication,
        TechKeyword,
        FavoriteJob,
        State,
        JobTitle,
        JobTitleAlias,
        User
      }
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
