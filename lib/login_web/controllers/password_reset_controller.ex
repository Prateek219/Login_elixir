defmodule LoginWeb.PasswordResetController do
    use LoginWeb, :controller
    alias Login.CRM
    def new(conn, _params) do
      render(conn, "new.html")
      end
    def create(conn, %{"email" => email}) do
      case CRM.get_customer_by_credentials(email) do
        nil ->
          conn
          |> put_flash(:info, "No email exists")
          |> redirect(to: Routes.password_reset_path(conn, :new))
    
        customer ->
          customer
          |> CRM.set_token_on_customer()
          conn
          |> put_flash(:info, " Email sent with password reset instructions")
          |> redirect(to: Routes.password_reset_path(conn, :new))
    
      end
    end
    def edit(conn, %{"id" => token}) do
      if customer =   CRM.get_customer_from_token(token) do
        changeset = CRM.change_customer(customer)
        render(conn, "edit.html", customer: customer, changeset: changeset)
      else
        render(conn, "invalid_token.html")
      end
    end
    def update(conn, %{"id" => token, "customer" => pass_attrs}) do
      customer = CRM.get_customer_from_token(token)
    
      pass_attrs =
        Map.merge(pass_attrs, %{"password_hash_reset_token" => nil, "password_hash_reset_sent_at" => nil})
    
      with true <- CRM.valid_token?(customer.password_reset_sent_at),
           {:ok, _updated_customer} <- CRM.update_customer(customer, pass_attrs) do
    
           conn
           |> put_flash(:info, "Your password has been reset. Sign in below with your new password.")
           |> redirect(to: Routes.session_path(conn, :new))
    
      else
        {:error, changeset} ->
          conn
          |> put_flash(:error, "Problem changing your password")
          |> render("edit.html", customer: customer, changeset: changeset)
    
        false ->
          conn
          |> put_flash(:error, "Reset token expired - request new one")
          |> redirect(to: Routes.password_reset_path(conn, :new))
    
      end
    end
    
  end