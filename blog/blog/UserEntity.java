package blog;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class UserEntity {
    @Parent Key<MyUser> userName;
    @Id Long id;
    @Index User user;
    @Index boolean isSubscribed = false;
    @Index String email;
    public UserEntity() {}
    public UserEntity(User user, String userName, boolean isSubscribed, String email) {
        this.user = user;
        this.isSubscribed = isSubscribed;
        this.email = email;
        this.userName = Key.create(MyUser.class, userName);
    }

    public User getUser() {
        return user;
    }

    public boolean isSubscribed() {
        return isSubscribed;
    }

    public void setSubscribed(boolean subscribed) {
        isSubscribed = subscribed;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }
}

