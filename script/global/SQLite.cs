using System.Data;
using Godot;
using Microsoft.Data.Sqlite;


[GlobalClass]
public partial class SQLite : RefCounted
{

    SqliteConnection _connection;

    public SQLite(string path)
    {
        if (!StringExtensions.IsAbsolutePath(path))
        {
            GD.PrintErr("SQLite => res:// 로 패스 등록");
            return;
        }
        
        _connection = new SqliteConnection(
            "Data Source="
            + ProjectSettings.GlobalizePath(path) + ";"
        );
        
        _connection.Open();
        // _connection.CreateCommand();
    }



    public static SQLite create(string path) => new SQLite(path);

}