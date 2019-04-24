
import ge.koaladev.utils.GeoSimpleDateFormat;
import java.util.Calendar;
import org.junit.Test;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author mindia
 */
public class GeoSimpleDateFormatTest {

    @Test
    public void dateFullFormatTest() {

        // EEEE [ full week name ]  MMMM [full month name]  yyy [ full year ]
        GeoSimpleDateFormat dateFormat = new GeoSimpleDateFormat("EEEE MMMM yyy");

        Calendar c = Calendar.getInstance();
        c.set(2010, 0, 1);

        //assert "????????? ??????? 2010".equals(dateFormat.format(c.getTime()));

    }

    @Test
    public void dateShortFormatTest() {

        // E [ short week name ]  MMM [short month name]  yyy [ full year ]
        GeoSimpleDateFormat dateFormat = new GeoSimpleDateFormat("E MMM yyy");

        Calendar c = Calendar.getInstance();
        c.set(2010, 0, 1);
        //assert "??? ??? 2010".equals(dateFormat.format(c.getTime()));

    }
}