package database;

import javax.ejb.Remote;
import javax.ejb.Stateless;
import javax.sql.DataSource;
import java.sql.*;
import java.util.List;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.ArrayList;


@Stateless(name="DatabaseBean", mappedName="ejb/DatabaseBean")
@Remote(Database.class)
public class OracleDatabaseBean implements Database{
    /**
     * Private fields
     */
    private static final Integer TIMEOUT = 60;
    private static final String NAME = "OracleDatabaseManual";

    /**
     * Constructors
     */
    public OracleDatabaseBean(){
    }

    /**
     * Public methods
     */
    @Override
    public List<Row> execute(Integer code, String name){
        List<Row> out = new ArrayList<>();
        out.clear();
        try(Connection connect = this.getConnection()){
            try(Statement statement = connect.createStatement()){
                statement.setQueryTimeout(TIMEOUT);
                ResultSet set = statement.executeQuery(Request.create(code, name));
                if(!set.isClosed()){
                    while(set.next()){
                        out.add(new Row(set.getString("flag"),
                                set.getString("country"),
                                set.getInt("code"),
                                set.getString("currency"),
                                set.getString("name"),
                                set.getDouble("rate")));
                    }
                }
            }
        }
        catch(NamingException E){
            System.err.println("Naming exception: " + E.getLocalizedMessage());
        }
        catch(SQLException E){
            System.err.println("SQL exception: " + E.getLocalizedMessage());
        }
        return out;
    }

    /**
     * Private methods
     */
    private DataSource getSource() throws NamingException{
        return (DataSource)(new InitialContext()).lookup(NAME);
    }
    private Connection getConnection() throws NamingException, SQLException{
        return this.getSource().getConnection();
    }
}
