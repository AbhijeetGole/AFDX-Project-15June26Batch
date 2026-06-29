public without sharing class CancelFlightBooking {
    public class FlightCancelRequest {
        @InvocableVariable(description='Booking Record Id')
        public String bookingid;

        @InvocableVariable(description='store the days count between travel start date and today date')
        public Decimal daysbetweencount;

        @InvocableVariable(description='Customer is Priority Member or not')
        public Boolean priortymember;

        @InvocableVariable(description='Booking Price')
        public Decimal bookingprice;
    }

    public class FlightCancelResponse {    
        @InvocableVariable(description='Amount that will be refunded')
        public Decimal refundedamount;

        @InvocableVariable(description='Case Number')
        public String casenumber;
    }

    @InvocableMethod(label='Cancel Booking' description='Cancel booked flights')
    public static List<FlightCancelResponse> cancelBooking(List<FlightCancelRequest> req) {
        List<FlightCancelResponse> responses = new List<FlightCancelResponse>();
        if(req != null && req.size()>0){
            FlightCancelRequest fcr = req[0];
            FlightCancelResponse fcrs = new FlightCancelResponse();
            Integer noOfDays = fcr.daysbetweencount != null ? Integer.valueOf(fcr.daysbetweencount) : 20;
            if(noOfDays>10 || (noOfDays<10 && noOfDays>5 && fcr.priortymember == true)){
                fcrs.refundedamount = fcr.bookingprice;
            } else if(noOfDays<10 && noOfDays>5 && fcr.priortymember == false){
                fcrs.refundedamount = fcr.bookingprice * 0.70;
            } else if(noOfDays<5 &&  fcr.priortymember == false){
                fcrs.refundedamount = 0;
            } else if(noOfDays<5 &&  fcr.priortymember == true){
                fcrs.refundedamount = fcr.bookingprice * 0.60;
            }
            
            /*if(fcr.priortymember == true){
                fcrs.refundedamount = fcr.bookingprice;
            } else {
                fcrs.refundedamount = fcr.bookingprice * 0.60;
            }*/
            
            Booking_Case__c bookingcase = new Booking_Case__c();
            bookingcase.Flight_Booking__c = fcr.bookingid;
            insert bookingcase;

            List<Booking_Case__c> bookingcases;
            if(bookingcase  != null){
                bookingcases = [SELECT Id, Name, Flight_Booking__c FROM Booking_Case__c WHERE Id = :bookingcase.Id];
                if(bookingcases != null && bookingcases.size()>0){
                    fcrs.casenumber = bookingcases[0].Name;
                }
            }            
            responses.add(fcrs);
        }
        return responses;
    }
}