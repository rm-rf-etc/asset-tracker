defmodule AssetTracker do
  def assets_db(path) do
    {:ok, db} = Depo.open(or_create: Path.join(path, "assets.sqlite3"))

    Depo.transact(db, fn ->
      Depo.write(db, "CREATE TABLE IF NOT EXISTS assets (name TEXT, blob BLOB)")

      Depo.teach(db, %{
        add: "INSERT OR REPLACE INTO assets VALUES (?1, ?2)",
        all: "SELECT * FROM assets",
        get: "SELECT * FROM assets WHERE name = ?1 LIMIT 1",
        find: "SELECT * FROM assets WHERE blob LIKE '%\"' || ?1 || '\":' || ?2 || '%' LIMIT 1"
      })
    end)

    {:ok, db}
  end

  def candles_db(path, name) when is_binary(name) do
    if !File.dir?(path), do: {:error, :invalid_path}
    if String.match?(name, ~r/^[\w]+$/), do: {:error, :invalid_name}
    {:ok, db} = Depo.open(or_create: Path.join(path, "#{name}.sqlite3"))

    Depo.transact(db, fn ->
      Depo.write(db, "CREATE TABLE IF NOT EXISTS #{name} (o TEXT, h TEXT, l TEXT, c TEXT, v INT)")

      Depo.teach(db, %{
        add: "INSERT OR REPLACE INTO #{name} VALUES (?1, ?2, ?3, ?4, ?5)",
        all: "SELECT * FROM #{name}"
      })
    end)

    {:ok, db}
  end
end
