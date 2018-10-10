import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.Date;

@Entity
public class Post implements Comparable<Post> {
    @Parent Key<MyUser> userName;
    @Id Long id;
    @Index User user;
    @Index String content;
    @Index Date date;
    public Post(User user, String content, String userName) {
        this.user = user;
        this.content = content;
        this.userName = Key.create(MyUser.class, userName);
        date = new Date();
    }

    public User getUser() {
        return user;
    }
    public String getContent() {
        return content;
    }

    @Override
    public int compareTo(Post other) {
        if (date.after(other.date))
            return 1;
        else if (date.before(other.date))
            return -1;
        return 0;
    }
}
