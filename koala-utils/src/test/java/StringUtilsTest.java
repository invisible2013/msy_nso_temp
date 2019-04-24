
import ge.koaladev.utils.StringUtils;
import static org.junit.Assert.assertEquals;
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
public class StringUtilsTest {

    @Test
    public void isNotEmptyTest() {
        assertEquals(true, StringUtils.isNotEmptyAndNull("This is not empty text"));
    }

    @Test
    public void isEmptyButNotNullTest() {
        assertEquals(false, StringUtils.isNotEmptyAndNull(""));
    }

    @Test
    public void isEmptyAndNullTest() {
        assertEquals(false, StringUtils.isNotEmptyAndNull(null));
    }
}
