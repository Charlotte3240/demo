
import React, {useState} from "react";
import {StyleSheet,Text,TouchableOpacity,View} from 'react-native';

const HCFlex = () => {
    const [flexDirection, setFlexDirection] = useState('column');

    return(
        <PreviewLayout 
            label="flex direction label"
            values={["column","row","row-reverse","column-reverse"]}
            selectedValue={flexDirection}
            setSelectedValue={setFlexDirection}
            >
            <View style={[styles.box, { backgroundColor: "powderblue" }]}/>
            <View
                style={[styles.box, { backgroundColor: "skyblue" }]}
            />
            <View
                style={[styles.box, { backgroundColor: "steelblue" }]}
            />
        </PreviewLayout>
    );
}

const PreviewLayout = ({
    label,
    children,
    values,
    selectedValue,
    setSelectedValue,
}) => (
    <View style={{padding:10, flex:1 ,backgroundColor:'blue'}}>
        <Text style={styles.label}>{label}</Text>
        <View style={styles.row}>{
            values.map((value) => (
                <TouchableOpacity key={value}
                    onPress={()=>setSelectedValue(value)}
                    style={[
                        styles.button,
                        selectedValue === value && styles.selected
                    ]}
                >
                    <Text style={[
                        styles.buttonLabel,
                        selectedValue === value && styles.selectedLabel
                    ]}>
                        {value}
                    </Text>
                </TouchableOpacity>
            ))
        }
        </View>

        <View style={[styles.container,{[label]:selectedValue}]}>
            {children}
        </View>

    </View>

);



const styles = StyleSheet.create({
    container:{
        flex:1,
        marginTop:30,
        backgroundColor:'aliceblue'
    },
    box:{
        width:50,
        height:50
    },
    label:{
        textAlign:'center',
        marginBottom:10,
        fontSize:24,
        height:30
    },
    row:{
        flexDirection:'row',
        flexWrap:'wrap',
        height:30

    },
    button:{
        paddingHorizontal:8,
        paddingVertical:6,
        borderRadius:5,
        backgroundColor:'oldlace',
        alignSelf:'flex-start',
        marginHorizontal:'1%',
        marginBottom:6,
        minWidth:'48%',
        textAlign: "center",


    },
    selected:{
        backgroundColor: "coral",
        borderWidth: 0,
    },
    selectedLabel:{
        color: "white",
    },
    buttonLabel:{
        color: "coral",
        fontSize: 12,
        fontWeight:'600',
        textAlign:'center'
    },
});

export default HCFlex;