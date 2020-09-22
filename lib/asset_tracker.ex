defmodule AssetTracker do
  def start do
    {:ok, db} = Depo.open(or_create: "assets.sqlite3")

    Depo.transact(db, fn ->
      Depo.write(db, "CREATE TABLE IF NOT EXISTS assets (name)")

      Depo.teach(db, %{
        insert: "INSERT INTO assets VALUES (?1)",
        get: "SELECT * FROM assets WHERE name = (?1)"
      })
    end)

    {:ok, db}
  end
end
