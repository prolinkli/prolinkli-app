package com.prolinkli.framework.exception.exceptions.model;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.CONFLICT)
public class ResourceAlreadyExists extends RuntimeException {

  public ResourceAlreadyExists() {
    super("Resource already exists");
  }

  public ResourceAlreadyExists(String message) {
    super(message);
  }

}
