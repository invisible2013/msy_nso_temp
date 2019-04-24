/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.misc;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import static ge.koaladev.msy.nso.core.misc.JsonDateDeSerializeSupport.DATE_FORMAT;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author mindia
 */
public class JsonDateSerializeSupport extends JsonSerializer<Date> {

    @Override
    public void serialize(Date t, JsonGenerator jg, SerializerProvider sp) throws IOException, JsonProcessingException {
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT);
        jg.writeString(t != null ? dateFormat.format(t) : "");
    }

}
