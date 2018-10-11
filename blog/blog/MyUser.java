package blog;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class MyUser {
    @Id long id;
    String name;
    private String email;
    private boolean isSubscribed = false;
    
    public MyUser(String name) {
        this.name = name;
    }

    public void setSubscribed(boolean subscribed) {
        this.isSubscribed = subscribed;
    }
    public boolean isSubscribed() {
        return isSubscribed;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

}
