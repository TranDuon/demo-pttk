package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Gói: model
 * Lớp thực thể MembershipCard7 (biểu đồ lớp thiết kế modul đăng kí thành viên).
 * Ở thiết kế CSDL, tblMembershipCard7 được gộp vào tblCustomer7 (quan hệ 1-1),
 * nên cardCode, points, issueDate là các cột của tblCustomer7.
 * [add] Bảng thẻ đã bỏ cột id khi gộp, nhưng lớp thực thể vẫn giữ id: id thẻ = id khách hàng (gán trong createCard()).
 * Kịch bản v3 bước 17-19: MembershipCardDAO7.createCard() gọi hàm khởi tạo MembershipCard7() để đóng gói thông tin.
 */
public class MembershipCard7 implements Serializable {
    private int id;
    private String cardCode;
    private int points;
    private Date issueDate;

    public MembershipCard7() {
        super();
    }

    public MembershipCard7(int id, String cardCode, int points, Date issueDate) {
        super();
        this.id = id;
        this.cardCode = cardCode;
        this.points = points;
        this.issueDate = issueDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCardCode() {
        return cardCode;
    }

    public void setCardCode(String cardCode) {
        this.cardCode = cardCode;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }
}
