/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.misc;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author mindia
 */
public class JsonDateDeSerializeSupport extends JsonDeserializer<Date> {

    public static final String DATE_FORMAT = "dd/MM/yyyy";

    @Override
    public Date deserialize(JsonParser jp, DeserializationContext dc) throws IOException, org.codehaus.jackson.JsonProcessingException {
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);
        try {
            return dateFormat.parse(jp.getText());
        } catch (ParseException ex) {
            return null;
        }
    }

}
