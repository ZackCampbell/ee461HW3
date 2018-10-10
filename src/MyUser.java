import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class MyUser {
    @Id long id;
    String name;
    
    public MyUser(String name) {
        this.name = name;
    }
}
