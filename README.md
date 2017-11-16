#Test with: http://editor.swagger.io/

swagger: '2.0'
info:
  version: 1.0.0
  title: Authenticate Microservice
  description: Ruby + MySQL Database
  contact:
      name: Liseth Briceño Albarracin
      email: lgbricenoa@unal.edu.co
  license:
    name: Software Architecture 2017-II
host: 192.168.99.101:3000
basePath: /
schemes:
  - http
consumes:
  - application/json
produces:
  - application/json
paths:
  /users:
    post:
      summary: Creates a new user
      operationId: createUser
      parameters:
        - name: user
          in: body
          required: true
          description: User Object
          schema:
            $ref: '#/definitions/User'
      responses:
        '201':
          description: Created
        '400':
          description: Bad Request
          schema:
            $ref: '#/definitions/ErrorModel'
        '500':
          description: Internal Server Error
          schema:
            $ref: '#/definitions/ErrorModel'
    
    /authenticate:
    post:
        summary: Authenticate a user
        operationId: authenticateUser
        parameters:
        - email :user 
        - password : user
          in body
          required: true 
          description: User Object
          schema:
           $ref: '#/definitions/User'
        responses:
        '200':
            description: return token jwt
        '401':
            description: invalid credentials
    
    /authorize:
    
        summary: Authorized a user
        operationId: authorizateUser
        parameters:
        -Authorization : jwt 
            in: headers
            required: true
            description: User Object
            schema:
            $ref: '#/definitions/User'
        responses:
        '200':
            description: current_user
        '401':
            description: Unauthorized
            
definitions:
# Products
  User:
    type: object
    properties:
      id:
        type: integer
      first_name:
        type: string
      last_name:
        type: string
      age:
        type: number
      password_digest:
        type: string

  

# Errors
  ErrorModel:
    type: object
    required:
      - message
      - code
    properties:
      message:
        type: string
      code:
        type: number
      description:
        type: object
