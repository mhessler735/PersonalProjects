
public class PromoOffering{
    double regularPrice;
    double promoPrice;

    /* Method creates a new promo price, but still maintains a regular price
    so that they may be compared  and returned to the regular price whe the promotion ends */
    public void promoPrice(double regularPrice, double promoPrice)){
        this.promoPrice = promoPrice; 
    }
}