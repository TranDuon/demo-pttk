package model;

import java.io.Serializable;

/**
 * Gói: model
 * Lớp thực thể trừu tượng User7 (biểu đồ lớp thực thể pha thiết kế - Task 8, mục 1).
 * Là lớp cha của Customer7, SalesStaff7, Manager7.
 * Bảng tương ứng: tblUser7(id, username, password, fullName).
 */
public abstract class User7 implements Serializable {
    private int id;
    private String username;
    private String password;
    private String fullName;

    public User7() {
        super();
    }

    public User7(int id, String username, String password, String fullName) {
        super();
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
}
