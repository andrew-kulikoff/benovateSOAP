package database;

import java.io.Serializable;

public class Row implements Serializable{
    private String flag = "";
    private String country = "";
    private String currency = "";
    private String name = "";
    private Integer code = 0;
    private Double rate = 0.0;

    public Row(){

    }
    public Row(String flag, String country, Integer code,
               String currency, String name, Double rate){
        this.setFlag(flag);
        this.setCountry(country);
        this.setCode(code);
        this.setCurrency(currency);
        this.setName(name);
        this.setRate(rate);
    }

    /**
     * Getters
     */
    public String getFlag(){
        return this.flag.toLowerCase();
    }
    public String getCountry(){
        return this.country;
    }
    public String getCurrency(){
        return this.currency.toUpperCase();
    }
    public String getName(){
        return this.name;
    }
    public Integer getCode(){
        return this.code;
    }
    public Double getRate(){
        return this.rate;
    }

    /**
     * Setters
     */
    public void setFlag(String value){
        this.flag = value;
    }
    public void setCountry(String value){
        this.country = value;
    }
    public void setCurrency(String value){
        this.currency = value;
    }
    public void setName(String value){
        this.name = value;
    }
    public void setCode(Integer value){
        this.code = value;
    }
    public void setRate(Double value){
        this.rate = value;
    }
}
