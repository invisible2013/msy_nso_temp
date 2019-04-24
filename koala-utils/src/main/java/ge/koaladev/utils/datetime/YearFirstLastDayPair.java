package ge.koaladev.utils.datetime;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by mindia on 3/26/17.
 */
public class YearFirstLastDayPair {

    private int year;
    private Date firstDay;
    private Date lastDay;

    public YearFirstLastDayPair(int year) {
        this.year = year;

        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.DAY_OF_YEAR, 1);
        firstDay = cal.getTime();

        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, 11); // 11 = december
        cal.set(Calendar.DAY_OF_MONTH, 31); // new years eve

        lastDay = cal.getTime();
    }

    public Date getFirstDay() {
        return firstDay;
    }

    public void setFirstDay(Date firstDay) {
        this.firstDay = firstDay;
    }

    public Date getLastDay() {
        return lastDay;
    }

    public void setLastDay(Date lastDay) {
        this.lastDay = lastDay;
    }
}
