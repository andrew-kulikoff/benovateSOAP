package database;

public class Request {
    private static final String SQL_REQUEST_PART_MAIN = "select A.flag as flag, "
                                                      + "       A.code as code, "
                                                      + "       A.currency as currency, "
                                                      + "       A.rate as rate, "
                                                      + "       B.text as country, "
                                                      + "       C.text as name "
                                                      + "  from ( select distinct a.id as currency_id, "
                                                      + "                         b.id as country_id, "
                                                      + "                         b.visa_country_code as flag, "
                                                      + "                         a.code as code, "
                                                      + "                         a.name as currency, "
                                                      + "                         r.p0164_2 as rate "
                                                      + "                    from com_currency a, "
                                                      + "                         com_country b, "
                                                      + "                         mcw_currency_rate r "
                                                      + "                   where a.code = b.curr_code "
                                                      + "                         and r.p0164_1 = a.code "
                                                      + "                         and r.p0164_3 = 'S' "
                                                      + "                         and b.visa_country_code is not null ";

    private static final String SQL_REQUEST_PART_CODE = "                         and a.code = ";

    private static final String SQL_REQUEST_PART_NAME = "                         and a.name = '";

    private static final String SQL_REQUEST_PART_I18N = "         ) A,"
                                                      + "         ( select distinct i.text as text, "
                                                      + "                           i.object_id as id "
                                                      + "                      from com_i18n i "
                                                      + "                     where i.table_name = 'COM_COUNTRY' "
                                                      + "                       and i.lang = 'LANGRUS' ) B, "
                                                      + "         ( select distinct i.text as text, "
                                                      + "                           i.object_id as id "
                                                      + "                      from com_i18n i "
                                                      + "                     where i.table_name = 'COM_CURRENCY' "
                                                      + "                       and i.lang = 'LANGRUS' ) C "
                                                      + "   where B.id = A.country_id "
                                                      + "     and C.id = A.currency_id "
                                                      + "order by B.text asc";

    public Request(){}

    public static String create( Integer code, String name ){
        return SQL_REQUEST_PART_MAIN +
               ( (code == null || code <= 0) ? "" : SQL_REQUEST_PART_CODE + code.toString() ) +
               ( name.isEmpty() ? "" : SQL_REQUEST_PART_NAME + name.toString() + "'" ) +
               SQL_REQUEST_PART_I18N;
    }
}
