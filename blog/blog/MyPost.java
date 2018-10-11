package blog;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class MyPost {
    @Id
    long id;
    String name;

    public MyPost(String name) {
        this.name = name;
    }

}

