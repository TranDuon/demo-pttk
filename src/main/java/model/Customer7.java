package model;

import java.util.Date;

/**
 * Gói: model
 * Lớp thực thể Customer7, kế thừa User7 (biểu đồ lớp thiết kế modul đăng kí thành viên).
 * Quan hệ: Customer7 chứa MembershipCard7 (composition, 1 - 0..1).
 * Bảng tương ứng: tblCustomer7(userId, phoneNumber, email, dateOfBirth, cardCode, points, issueDate).
 * Kịch bản v3 bước 9-11: doRegisterMembership7.jsp gọi các hàm setter() của lớp này.
 */
public class Customer7 extends User7 {
    private String phoneNumber;
    private String email;
    private Date dateOfBirth;
    private MembershipCard7 membershipCard;

    public Customer7() {
        super();
    }

    public Customer7(int id, String username, String password, String fullName,
            String phoneNumber, String email, Date dateOfBirth, MembershipCard7 membershipCard) {
        super(id, username, password, fullName);
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.dateOfBirth = dateOfBirth;
        this.membershipCard = membershipCard;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public MembershipCard7 getMembershipCard() {
        return membershipCard;
    }

    public void setMembershipCard(MembershipCard7 membershipCard) {
        this.membershipCard = membershipCard;
    }
}
