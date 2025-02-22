using Microsoft.SqlServer.Server;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

public partial class StoredProcedures
{

    public static void AccountBalances()
    {
        using (SqlConnection conn = new SqlConnection("context connection=true;"))
        {
            SqlCommand comm = new SqlCommand();
            comm.Connection = conn;
            comm.CommandText = @"SELECT actid, tranid, val
                                   FROM dbo.Transactions
                                   ORDER BY actid, tranid;";
            SqlMetaData[] columns = new SqlMetaData[4];
            columns[0] = new SqlMetaData("actid", SqlDbType.Int);
            columns[1] = new SqlMetaData("tranid", SqlDbType.Int);
            columns[2] = new SqlMetaData("val", SqlDbType.Money);
            columns[3] = new SqlMetaData("balance", SqlDbType.Money);

            SqlDataRecord record = new SqlDataRecord(columns);
            SqlContext.Pipe.SendResultsStart(record);
            conn.Open();

            SqlDataReader reader = comm.ExecuteReader();

            SqlInt32 prvactid = 0;
            SqlMoney balance = 0;

            while (reader.Read())
            {
                SqlInt32 actid = reader.GetSqlInt32(0);
                SqlMoney val = reader.GetSqlMoney(2);

                if(actid == prvactid)
                {
                    balance += val;
                }
                else
                {
                    balance = val;
                }
                prvactid = actid;

                record.SetSqlInt32(0, reader.GetSqlInt32(0));
                record.SetSqlInt32(1, reader.GetSqlInt32(1));
                record.SetSqlMoney(2, val);
                record.SetSqlMoney(3, balance);

                SqlContext.Pipe.SendResultsRow(record);
            }
            SqlContext.Pipe.SendResultsEnd();
        }
    }
}

