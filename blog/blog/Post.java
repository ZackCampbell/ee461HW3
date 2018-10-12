package blog;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.Comparator;
import java.util.Date;

@Entity
public class Post implements Comparable<Post> {
    @Parent Key<MyPost> postName;
    @Id Long id;
    @Index User user;
    @Index String content;
    @Index Date date;
    @Index String title;
    @Index String rating;
    public Post() {}
    public Post(User user, String content, String postName, String title, String rating) {
        this.user = user;
        this.title = title;
        this.content = content;
        this.rating = rating;
        this.postName = Key.create(MyPost.class, postName);
        date = new Date();
    }

    public Date getDate() {
        return date;
    }

    public User getUser() {
        return user;
    }
    public String getContent() {
        return content;
    }

    public String getTitle() {
        return title;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    @Override
    public int compareTo(Post other) {
        if (date.after(other.date))
            return -1;
        else if (date.before(other.date))
            return 1;
        return 0;
    }
}
