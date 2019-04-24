/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

/**
 *
 * @author mindia
 */
public interface Parsable<T, K> {

    T parse(K k);

}
