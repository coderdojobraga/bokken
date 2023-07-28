defmodule BokkenWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BokkenWeb, :controller
      use BokkenWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths, do: ~w(images favicon.ico dojo.html robots.txt)

  def controller(version \\ "1.7") do
    result =
      case version do
        "1.7" ->
          quote do
            use Phoenix.Controller,
              namespace: BokkenWeb,
              formats: [:html, :json],
              layouts: [html: BokkenWeb.Layouts]
          end

        _ ->
          quote do
            use Phoenix.Controller, namespace: BokkenWeb
          end
      end

    quote do
      unquote(result)

      import Plug.Conn
      import BokkenWeb.Gettext
      import Bokken.Guards
      alias BokkenWeb.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/bokken_web/templates",
        namespace: BokkenWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def email_view do
    quote do
      use Phoenix.Swoosh, view: BokkenWeb.EmailView, layout: {BokkenWeb.LayoutView, :email}

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BokkenWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import BokkenWeb.ErrorHelpers
      import BokkenWeb.Gettext
      alias BokkenWeb.Router.Helpers, as: Routes

      import BokkenWeb.ViewUtils

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: BokkenWeb.Endpoint,
        router: BokkenWeb.Router,
        statics: BokkenWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(controller: "1.6" = version) do
    controller(version)
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
