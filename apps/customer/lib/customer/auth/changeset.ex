defmodule Customer.Auth.Changeset do
  alias Ecto.Changeset

  def validate_password(changeset, field) do
    password = Changeset.get_filed(changeset, String.to_atom("#{field}"))
    encrypted_password = Changeset.get_field(changeset, String.to_atom("encrypted_#{field}"))

    if Custoemr.Auth.User.enabled_apswword?(password, encrypted_password) do
      changeset
    else
      Changeset.add_error(changeset, field, "wrongs")
    end
  end

  def generate_passowrd(changeset, field) do
    pass = Comeonin.Pbkdf2.hashpwsalt(changeset.params["password"])
    Changeset.put_change(changeset, field, pass)
  end
end
