/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import ge.koaladev.utils.StringMatcher;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author mindia
 */
public class StringMatcherTest {

    @Test
    public void isEmailTest() {
        assertEquals(true, StringMatcher.isEmail("somemail@gmail.com"));
    }

    @Test
    public void isNotEmailTest() {
        assertEquals(false, StringMatcher.isEmail("somemail gmail.com"));
    }
}
