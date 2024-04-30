const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.addRentalProperty = functions.https.onCall((data, context) => {
    // Check if the user is authenticated
    if (!context.auth) {
        throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }

    // Constructing the property object from the data provided
    const property = {
        propertyId: data.propertyId,
        propType: data.propType,
        bedrooms: data.bedrooms,
        bathrooms: data.bathrooms,
        totalArea: data.totalArea,
        carpetArea: data.carpetArea,
        rentPerMonth: data.rentPerMonth,
        floorOfProp: data.floorOfProp,
        totalFloors: data.totalFloors,
        noOfFlats: data.noOfFlats,
        imageUrls: data.imageUrls, // Ensure this is an array of strings
        extraDetails: data.extraDetails || null, // Optional field
        postedDate: data.postedDate // Ensure this is a valid date string or timestamp
    };

    // Add the property to your database
    return admin.firestore().collection('properties').add(property)
        .then(() => {
            return { message: 'Property added successfully!' };
        })
        .catch(error => {
            throw new functions.https.HttpsError('internal', 'An error occurred while adding the property', error);
        });
});
