require 'net/http'
require 'net/https'
require 'open-uri'
require 'json'

# GenderMapper Class that uses the gender-api to determine gender of a person using name and country
# Author: Xiaohang Wang
class GenderMapper
                GENDER_MALE  = "Male"
                GENDER_FEMALE = "Female"
                GENDER_UNKNOWN = "Unknown"
                #first name should be string
                def get_gender( first_name, country_code, key = "UQwTfxTauAYyKdwLLE" )
                  
                  #convert first name to downcase
                  each_name = first_name.downcase
                  
                  #get gender info from web
                  uri = 'https://gender-api.com/get?name='+each_name+'&country='+country_code+'&key='+key
                  encoded = URI.encode( uri )
                  data = URI.parse( encoded ).read
                  parsed_data = JSON.parse(data )
                  
                  #determine returned gender and return
                  if(parsed_data["gender"] == nil)
                    return GENDER_UNKNOWN
                  else
                    (parsed_data["gender"].strip == "male") ? (return GENDER_MALE) : (return GENDER_FEMALE)
                  end
                 
                
                end
end

# Genders Controller
class GendersController < ApplicationController
   def new
   end

   def create
	# Query the DB to see a record of the same name already exists
	if temp = Gender.find_by_name(gender_params[:name])
		# Update the place
		temp.place = gender_params[:place]
		
		# Update the Record in DB
		temp.save
		redirect_to temp
	else
		# Create new GenderMapper Object
		gend = GenderMapper.new
		@gender = Gender.new(gender_params)
		
		# Use the gender-api (query via internet) to determine gender of the person
		@gender.gender = gend.get_gender(@gender.name, @gender.place)

		# Save to DB
		@gender.save
		redirect_to @gender
	end
   end

   def show
	@gender = Gender.find(params[:id])
   end

  private
    def gender_params      
      params.require(:gender).permit(:name, :place, :gender)
    end
end
