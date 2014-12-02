import Vector::*;

import CacheTypes::*;
import MessageFifo::*;

module mkMessageRouter( Vector#( NumCaches, MessageFifo#( n )) c2r,
                        Vector#( NumCaches, MessageFifo#( n )) r2c,
                        MessageFifo#( n ) m2r,
                        MessageFifo#( n ) r2m,
                        Empty ifc );
    
    rule c2m;
        Bool done = False;
        for( Integer i = 0; !done && i < valueOf( NumCaches ); i = i + 1 ) begin
            if( c2r[ i ].notEmpty ) begin
                case( c2r[ i ].first ) matches
                    tagged Resp .resp: r2m.enq_resp( resp );
                    tagged Req  .req:  r2m.enq_req( req );
                endcase
                c2r[ i ].deq;
                done = True;
            end
        end
    endrule
    
    rule m2c( m2r.notEmpty );
        case( m2r.first ) matches
            tagged Resp .resp: r2c[ resp.child ].enq_resp( resp );
            tagged Req  .req:  r2c[ req.child ].enq_req( req );
        endcase
        m2r.deq;
    endrule
    
endmodule

