# Create layer commands

I did this through the terminal so kinda hacking it till i get it in a pipeline.

* Navigate into the lambda_layer/layter folder
* run the following commands:
    * `mkdir -p python`
    * `cd python`
    * `pip3 install --target=. -r ../requirements.txt`
    * `zip -r openserach.zip python`
