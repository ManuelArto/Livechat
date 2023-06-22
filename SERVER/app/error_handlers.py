from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse


def add_exception_handlers(app: FastAPI):
    """
    Adds exception handlers to the FastAPI app instance.

    :param app: A FastAPI instance to add exception handlers to.
    :return: None
    """

    @app.exception_handler(RequestValidationError)
    async def validation_exception_handler(_: Request, exc: RequestValidationError):
        details = [f"{error['loc'][-1]}: {error['msg']}" for error in exc.errors()]
        return JSONResponse(
            status_code=422,
            content={"error": ", ".join(details)},
        )

    @app.exception_handler(HTTPException)
    async def http_exception_handler(_: Request, exc: HTTPException):
        return JSONResponse(
            status_code=exc.status_code,
            content={"error": exc.detail},
        )

    @app.exception_handler(Exception)
    async def exception_handler(_: Request, exc: Exception):
        return JSONResponse(
            status_code=500,
            content={"error": f"Some internal error occured: {str(exc)}"},
        )
