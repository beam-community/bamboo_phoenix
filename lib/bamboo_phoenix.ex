defmodule Bamboo.Phoenix do
  @moduledoc """
  Render emails with Phoenix templates and layouts.

  This module allows rendering emails with Phoenix layouts and components. Pass an
  atom (e.g. `:welcome_email`) as the template name to render both HTML and
  plain text emails. Use a string if you only want to render one type, e.g.
  `"welcome_email.text"` or `"welcome_email.html"`.

  ## Examples

  _Set the text and HTML layout for an email._

      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def welcome_email do
          new_email()
          |> put_text_layout({MyAppWeb.Layouts, "email.text"})
          |> put_html_layout({MyAppWeb.Layouts, "email.html"})
          |> render(:welcome) # Pass atom to render html AND plain text templates
        end
      end

  _Set both the text and HTML layout at the same time for an email._

      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def welcome_email do
          new_email()
          |> put_layout({MyAppWeb.Layouts, :email})
          |> render(:welcome)
        end
      end

  _Render both text and html emails without layouts._

      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def welcome_email do
          new_email()
          |> render(:welcome)
        end
      end

  _Make assigns available to a template._

      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def welcome_email(user) do
          new_email()
          |> assign(:user, user)
          |> render(:welcome)
        end
      end

  _Make assigns available to a template during render call._

      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def welcome_email(user) do
          new_email()
          |> put_html_layout({MyAppWeb.Layouts, "email.html"})
          |> render(:welcome, user: user)
        end
      end

  _Render an email by passing the template string to render._

      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def html_email do
          new_email
          |> render("html_email.html")
        end

        def text_email do
          new_email
          |> render("text_email.text")
        end
      end

  ## HTML Layout Example

      # my_app_web/email.ex
      defmodule MyApp.Email do
        use Bamboo.Phoenix, component: MyAppWeb.EmailHTML

        def sign_in_email(person) do
          base_email()
          |> to(person)
          |> subject("Your Sign In Link")
          |> assign(:person, person)
          |> render(:sign_in)
        end

        defp base_email do
          new_email
          |> from("Rob Ot<robot@changelog.com>")
          |> put_header("Reply-To", "editors@changelog.com")
          # This will use the "email.html.eex" file as a layout when rendering html emails.
          # Plain text emails will not use a layout unless you use `put_text_layout`
          |> put_html_layout({MyAppWeb.Layouts, "email.html"})
        end
      end

      # my_app_web/components/email_html.ex
      defmodule MyAppWeb.EmailHTML do
        use MyAppWeb, :html
      end

      # my_app_web/templates/layout/email.html.eex
      <html>
        <head>
          <link rel="stylesheet" href="<%= static_url(MyApp.Endpoint, "/css/email.css") %>">
        </head>
        <body>
          <%= @inner_content %>
        </body>
      </html>

      # my_app_web/templates/email/sign_in.html.eex
      <p><%= link "Sign In", to: sign_in_url(MyApp.Endpoint, :create, @person) %></p>

      # my_app_web/templates/email/sign_in.text.eex
      # This will not be rendered within a layout because `put_text_layout` was not used.
      Sign In: <%= sign_in_url(MyApp.Endpoint, :create, @person) %>
  """

  import Bamboo.Email, only: [put_private: 3]

  defmacro __using__(component: component_module) do
    verify_phoenix_dep()

    quote do
      import Bamboo.Email
      import Bamboo.Phoenix, except: [render: 3]

      @doc """
      Render an Phoenix template and set the body on the email.

      Pass an atom as the template name (:welcome_email) to render HTML *and* plain
      text emails. Use a string if you only want to render one type, e.g.
      "welcome_email.text" or "welcome_email.html". Scroll to the top for more examples.
      """
      def render(email, template, assigns \\ []) do
        Bamboo.Phoenix.render_email(unquote(component_module), email, template, assigns)
      end
    end
  end

  defmacro __using__(opts) do
    raise ArgumentError, """
    expected Bamboo.Phoenix to have a component set, instead got: #{inspect(opts)}.

    Please set a component e.g. use Bamboo.Phoenix, component: MyAppWeb.EmailHTML
    """
  end

  defp verify_phoenix_dep do
    unless Code.ensure_loaded?(Phoenix) do
      raise "You tried to use Bamboo.Phoenix, but Phoenix module is not loaded. " <>
              "Please add phoenix to your dependencies."
    end
  end

  @doc """
  Render a Phoenix template and set the body on the email.

  Pass an atom as the template name to render HTML *and* plain text emails,
  e.g. `:welcome_email`. Use a string if you only want to render one type, e.g.
  `"welcome_email.text"` or `"welcome_email.html"`. Scroll to the top for more examples.
  """
  def render(_email, _template_name, _assigns) do
    raise "function implemented for documentation only, please call: use Bamboo.Phoenix"
  end

  @doc """
  Sets the layout when rendering HTML templates.

  ## Example

      def html_email_layout do
        new_email
        # Will use MyAppWeb.Layouts with email.html template when rendering html emails
        |> put_html_layout({MyAppWeb.Layouts, "email.html"})
      end
  """
  def put_html_layout(email, layout) do
    email |> put_private(:html_layout, layout)
  end

  @doc """
  Sets the layout when rendering plain text templates.

  ## Example

      def text_email_layout do
        new_email
        # Will use MyAppWeb.Layouts with email.text template when rendering text emails
        |> put_text_layout({MyAppWeb.Layouts, "email.text"})
      end
  """
  def put_text_layout(email, layout) do
    email |> put_private(:text_layout, layout)
  end

  @doc """
  Sets the layout for rendering plain text and HTML templates.

  ## Example

      def text_and_html_email_layout do
        new_email
        # Will use MyAppWeb.Layouts with the email.html template for html emails
        # and MyAppWeb.Layouts with the email.text template for text emails
        |> put_layout({MyAppWeb.Layouts, :email})
      end
  """
  def put_layout(email, {layout, template}) do
    email
    |> put_text_layout({layout, to_string(template) <> "_text"})
    |> put_html_layout({layout, to_string(template) <> "_html"})
  end

  @doc """
  Sets an assign for the email. These will be available when rendering the email
  """
  def assign(%{assigns: assigns} = email, key, value) do
    %{email | assigns: Map.put(assigns, key, value)}
  end

  @doc false
  def render_email(component, email, template, assigns) do
    email
    |> put_default_layouts
    |> merge_assigns(assigns)
    |> put_component(component)
    |> put_template(template)
    |> render
  end

  defp put_default_layouts(%{private: private} = email) do
    private =
      private
      |> Map.put_new(:html_layout, false)
      |> Map.put_new(:text_layout, false)

    %{email | private: private}
  end

  defp merge_assigns(%{assigns: email_assigns} = email, assigns) do
    assigns = email_assigns |> Map.merge(Enum.into(assigns, %{}))
    email |> Map.put(:assigns, assigns)
  end

  defp put_component(email, component_module) do
    email |> put_private(:component_module, component_module)
  end

  defp put_template(email, template) do
    email |> put_private(:template, template)
  end

  defp render(%{private: %{template: template}} = email) when is_atom(template) do
    template = Atom.to_string(template)

    %{email | private: %{email.private | template: template}}
    |> render_html_and_text_emails()
  end

  defp render(email) do
    render_text_or_html_email(email)
  end

  defp render_html_and_text_emails(email) do
    email
    |> Map.put(:html_body, render_html(email, email.private.template <> "_html"))
    |> Map.put(:text_body, render_text(email, email.private.template <> "_text"))
  end

  defp render_text_or_html_email(email) do
    template = email.private.template

    cond do
      String.ends_with?(template, "_html") ->
        email |> Map.put(:html_body, render_html(email, template))

      String.ends_with?(template, "_text") ->
        email |> Map.put(:text_body, render_text(email, template))

      true ->
        raise ArgumentError, """
        Template name must end in either ".html" or ".text". Template name was #{
          inspect(template)
        }

        If you would like to render both and html and text template,
        use an atom without an extension instead.
        """
    end
  end

  defp render_html(email, template) do
    # Phoenix uses the assigns.layout to determine what layout to use
    assigns = Map.put(email.assigns, :layout, email.private.html_layout)

    Phoenix.Template.render_to_string(
      email.private.component_module,
      template,
      "html",
      assigns
    )
  end

  defp render_text(email, template) do
    assigns = Map.put(email.assigns, :layout, email.private.text_layout)

    Phoenix.Template.render_to_string(
      email.private.component_module,
      template,
      "html",
      assigns
    )
  end
end
