
exports.lambdify = function (fun) {
    return function (event, context, callback) {
        context.callbackWaitsForEmptyEventLoop = false;
        fun(event)(callback.bind(null, null))();
    }
};
