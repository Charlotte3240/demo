import React from 'react';
import {Text,StyleSheet} from 'react-native'


const Comment = ({
    stringVar
}) => {
    return(
        <Text style={styles.comment}>{stringVar}</Text>
    )
}

const styles = StyleSheet.create({
    comment:{
        color:'gray',
        fontSize:20,
        textAlign:'center'
    }
})


export default Comment