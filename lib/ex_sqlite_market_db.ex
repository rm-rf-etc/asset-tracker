defmodule ExSqliteMarketDb do
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

  def chart_db(base_path, symbol, i6l)
      when is_binary(base_path) and is_binary(i6l) and is_binary(symbol) do
    if !File.dir?(base_path), do: {:error, :invalid_path}

    workdir = Path.join([base_path, symbol])

    if !File.dir?(workdir) do
      File.mkdir(workdir)
    end

    {:ok, db} = Depo.open(or_create: Path.join([workdir, "#{i6l}.sqlite3"]))

    Depo.transact(db, fn ->
      Depo.write(db, "CREATE TABLE IF NOT EXISTS #{i6l} (o TEXT, h TEXT, l TEXT, c TEXT, v INT)")

      Depo.teach(db, %{
        add: "INSERT OR REPLACE INTO #{i6l} VALUES (?1, ?2, ?3, ?4, ?5)",
        all: "SELECT * FROM #{i6l}"
      })
    end)

    {:ok, db}
  end
end
