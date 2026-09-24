import ballerina/constraint;
import ballerina/http;
import ballerina/time;

type DatabaseConfig readonly & record {|
    string url;
    string user;
    string password;
|};

type NewProduct record {|

    @constraint:String {
        minLength: 3,
        maxLength: 15
    }
    string name;

    @constraint:Int {
        minValue: 1,
        maxValue: 25
    }
    int qtz;
|};

type Product record {|
    readonly int id;
    string name;
    int qtz;
    time:Civil create_date;
    time:Civil update_date;
|};

type ProductWithMeta record {|
    readonly int id;
    string name;
    int qtz;
    record {|
        time:Date create_date;
        time:Date update_date;
    |} meta;
|};

type ErrorDetails record {|
    string message;
    time:Utc time;
|};

type ProductNotFound record {|
    *http:NotFound;
    ErrorDetails errorDetails;
|};
