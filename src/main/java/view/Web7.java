package view;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.Locale;

/** Hàm định dạng dùng chung cho JSP. */
public final class Web7 {
    private Web7() {}

    public static String text(String value) {
        return value == null ? "" : value.trim();
    }

    public static String html(String value) {
        return value == null ? "" : value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }

    public static java.sql.Date date(String value) {
        try {
            return java.sql.Date.valueOf(LocalDate.parse(text(value)));
        } catch (DateTimeParseException | IllegalArgumentException error) {
            return null;
        }
    }

    public static Integer id(String value) {
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException error) {
            return null;
        }
    }

    public static String format(Date date, String pattern) {
        return new SimpleDateFormat(pattern, Locale.ROOT).format(date);
    }

    public static String number(double amount) {
        return NumberFormat.getIntegerInstance(Locale.forLanguageTag("vi-VN")).format(amount);
    }
}
