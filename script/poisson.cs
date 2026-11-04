using System;
using System.Linq;
using Godot;
using Godot.Collections;



public partial class PoissonDisk : RefCounted
{

    public enum Type
    {
        NONE,
        LINE,
        POLYGON,
        CIRCLE,
    }

    private Type type = Type.NONE;
    private Vector2[] points;
    private Vector2 position;
    private float radius;

    public Vector2[] generate_points_in_polygon(
        Vector2[] polygon, float radius, int retry, Vector2 start_point
    )
    {
        var start = polygon[0];
        var end = polygon[0];

        for (var i = 1; i < polygon.Count(); i+=1)
        {
            start.X = Math.Min(start.X, polygon[i].X);
            start.Y = Math.Min(start.Y, polygon[i].Y);
            end.X = Math.Max(end.X, polygon[i].X);
            end.Y = Math.Max(end.Y, polygon[i].Y);
        }
        var _rect = new Rect2(start, end-start);

        if (float.IsInfinity(start_point.X))
        {
            var _n = polygon.Count();
            var i = new Random().NextInt64() % _n;
            start_point = polygon[i] + (polygon[(i + 1) % _n] - polygon[i]) * (float)new Random().NextDouble();
        }
        else if (Geometry2D.IsPointInPolygon(start_point, polygon))
        {
            GD.PushError("Starting point", start_point, "is not a valid point inside the polygon!");
            return [];
        }

        return _gen_points(_rect, radius, retry, start_point);
    }



    public Vector2[] _gen_points(Rect2 rect, float radius, int retry, Vector2 start_point)
    {
        var cell_size = radius / Math.Sqrt(2);
        var col = (float)Math.Max(Math.Floor(rect.Size.X / cell_size), 1);
        var row = (float)Math.Max(Math.Floor(rect.Size.Y / cell_size), 1);

        var cell_size_scaled = new Vector2(
            x: rect.Size.X / col, y: rect.Size.Y / row
        );

        var transpose = - rect.Position;
        var grid = new Array<Array<int>>();
        for (int i = 0; i < col; i+=1)
        {
            var _arr = new Array<int>();
            for (int j = 0; j < row; j += 1)
            {
                _arr.Add(-1);
            }
            grid.Add(_arr);
        }

        var spawn_points = new Array<Vector2>();
        spawn_points.Add(start_point);
        
        while (spawn_points.Count() > 0)
        {
            var spawn_idx = new Random().Next() % spawn_points.Count();
            var spawn_center = spawn_points[spawn_idx];
            var accepted = false;

            for (int i = 0; i < retry; i+=1)
            {
                var angle = (float)(2 * Math.PI * (float)new Random().NextDouble());
                var sample = spawn_center + new Vector2(Mathf.Cos(angle), Mathf.Sin(angle)) * (
                    radius + radius * (float)new Random().NextDouble()
                );
                // TODO
            }

        }

        

        return [];
    }


    private bool is_valid_sample(
        Vector2 sample, Vector2 transpose, Vector2 scale, int col, int row, Array<Array<Vector2>> grid, Array<Vector2> points, float radius
    )
    {
        var cell = new Vector2();

        return true;
    }

    private bool is_point_in_sample(Vector2 sample)
    {
        if (type == Type.POLYGON && Geometry2D.IsPointInPolygon(sample, points))
            return true;
        else if (type == Type.CIRCLE && Geometry2D.IsPointInCircle(sample, position, radius))
            return true;
        
        return false;
    }


}