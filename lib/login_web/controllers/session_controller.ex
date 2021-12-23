defmodule LoginWeb.SessionController do
    use LoginWeb, :controller
    def new(conn, _params) do
    render(conn, "new.html")
    end
    alias Login.CRM
    def create(conn, %{"session" => %{"email" => email, "password_hash" => password_hash}}) do
        case CRM.get_customer_by_credentials(email,password_hash) do
          :error ->
            conn
            |> put_flash(:error, "Invalid username/password combination")
            |> render("new.html")
          customer ->
            conn
            |> assign(:current_customer, customer)
            |> put_session(:customer_id, customer.id)
            |> configure_session(renew: true)
            |> put_flash(:info, "Login successful")
            |> redirect(to: Routes.page_path(conn, :index))
        end
      end
    
    end