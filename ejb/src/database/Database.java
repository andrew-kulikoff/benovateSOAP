package database;

import javax.ejb.Remote;
import java.util.List;

@Remote
public interface Database {
    List execute(Integer code, String name);
}

